from paho.mqtt import client as mqtt
import ssl

path_to_root_cert = "DigiCertAssuredIDRootG2.crt.pem"
device_id = "RB23GD1708"
sas_token = "SharedAccessSignature sr=gas-detekt-iot-hub.azure-devices.net%2Fdevices%2FRB23GD1708&sig=259N2AM1bbYCmcebwULAsE9xGHSJrHtmJzgOU3iEshw%3D&se=1686561945"
iot_hub_name = "gas-detekt-iot-hub"


def on_connect(client, userdata, flags, rc):
    print("Device connected with result code: " + str(rc))


def on_disconnect(client, userdata, rc):
    print("Device disconnected with result code: " + str(rc))


def on_publish(client, userdata, mid):
    print("Device sent message")


client = mqtt.Client(client_id=device_id, protocol=mqtt.MQTTv311)

client.on_connect = on_connect
client.on_disconnect = on_disconnect
client.on_publish = on_publish

client.username_pw_set(username=iot_hub_name+".azure-devices.net/" +
                       device_id + "/?api-version=2021-04-12", password=sas_token)

client.tls_set(ca_certs=path_to_root_cert, certfile=None, keyfile=None,
               cert_reqs=ssl.CERT_REQUIRED, tls_version=ssl.PROTOCOL_TLSv1_2, ciphers=None)

client.tls_insecure_set(False)

client.connect(iot_hub_name+".azure-devices.net", port=8883)

client.publish("devices/" + device_id + "/messages/events/", '{"id":123}', qos=1)
client.loop_forever()