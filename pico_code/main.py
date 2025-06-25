from machine import Pin, PWM
import utime
import json
import network
import urequests
import ujson


# Initialize the system LED
sys_led = Pin('LED', Pin.OUT)
sys_led.value(0)

def led_indicator():
    """Blink the LED to indicate activity."""
    sys_led.value(1)
    utime.sleep(0.5)
    sys_led.value(0)

def get_data():
    api='https://universal-remote-umber.vercel.app/getcmd'
    result=urequests.get(api)
    return result.json()

# Wi-Fi connection
SSID = 'YOUR WIFI NAME'          # Replace with your Wi-Fi SSID
PASSWORD = 'YOUR WIFI PASSWORD'  # Replace with your Wi-Fi password
wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect(SSID, PASSWORD)

# Wait for Wi-Fi connection
print("Connecting to Wi-Fi...")
while not wlan.isconnected():
    led_indicator()
    utime.sleep(1)

print("Connected to Wi-Fi!")
print("IP Address:", wlan.ifconfig())



################## Main ##################################


with open("remote_config.json") as file:
     data_set=json.load(file)

# Define IR LED pin
ir_led = PWM(Pin(15))
ir_led.freq(38000)  # NEC uses 38kHz
ir_led.duty_u16(0)  # Off by default

def send_pulse(high_time, low_time):
    ir_led.duty_u16(32768)  # 50% duty (max is 65535)
    utime.sleep_us(high_time)
    ir_led.duty_u16(0)
    utime.sleep_us(low_time)

def send_signal(pulses):
     for high, low in pulses:
            send_pulse(high, low)


result=get_data()
code=result["code"]
while True:
    try:
        result=get_data()
        if code!=result["code"]:
            led_indicator()
            data=result["data"]
            type=data["type"]
            model=data["model"]
            command=data["command"]    
            pulses=data_set[type][model][command]
            #print(pulses)
            send_signal(pulses)
            code=result["code"]
            #print("Executed")
    except:
         print("Error")
    utime.sleep(0.250)

