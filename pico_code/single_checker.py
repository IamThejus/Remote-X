from machine import Pin,PWM
import time

ir_pin = Pin(16, Pin.IN)

print("Ready to receive IR signal...")
# Define IR LED pin
ir_led = PWM(Pin(15))
ir_led.freq(38000)  # NEC uses 38kHz
ir_led.duty_u16(0)  # Off by default

def send_pulse(high_time, low_time):
    ir_led.duty_u16(32768)  # 50% duty (max is 65535)
    time.sleep_us(high_time)
    ir_led.duty_u16(0)
    time.sleep_us(low_time)

while True:
    if ir_pin.value() == 0:
        pulses = []
        start = time.ticks_us()

        while time.ticks_diff(time.ticks_us(), start) < 1000000:  # 0.5s window
            t1 = time.ticks_us()
            while ir_pin.value() == 0:
                pass
            t2 = time.ticks_us()
            while ir_pin.value() == 1:
                pass
            t3 = time.ticks_us()
            pulses.append((t2 - t1, t3 - t2))

        print("Pulses captured:")
        print(pulses)
        print("Waiting to send")
        time.sleep(2)
        print("send!")
        for high, low in pulses:
            send_pulse(high, low)

