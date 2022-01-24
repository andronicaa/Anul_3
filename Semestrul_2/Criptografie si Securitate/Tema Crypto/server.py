import socket
from Crypto import Random
import Crypto.Cipher.AES as AES
from Crypto.PublicKey import RSA


s = socket.socket()
print("Socket successfully created")

port = 12343

s.bind(('', port))
print("socket binded to %s" %(port))
s.listen(5)
print("socket is listening")

# generam cheia publica
random = Random.new().read
RSAkey = RSA.generate(1024, random)
public = RSAkey.publickey().exportKey()
private = RSAkey.exportKey()

# mesajul de criptat
encrypt_str = "encrypted_message="


while True:
    c, addr = s.accept()
    
    print("Got connection from ", addr)
    data = c.recv(2048)
    data = data.decode("utf-8")
    print(data)
    if data == 'Client: OK':
        print("Am primit OK-ul de la client")
        c.send(public)
        print("Am trimis cheia catre client")
    data = c.recv(2048)
    encrypted = eval(str(data))
    decrypted = private.decrypt(encrypted)
    print("Decrypted message = " + decrypted)
c.close()