# Import socket module 
import socket             
from Crypto import Random
import Crypto.Cipher.AES as AES
from Crypto.PublicKey import RSA




# Create a socket object 
s = socket.socket()         
  
# Define the port on which you want to connect 
port = 12343
  
# connect to the server on local computer 
s.connect(('127.0.0.1', port)) 

s.sendall(b"Client: OK")
# receive data from the server 
server_string = s.recv(2048)
server_string = server_string.replace(b"public_key=", b'')
server_string = server_string.replace(b"\r\n", b'')
server_string = server_string.decode("utf-8")
print(server_string)
# close the connection 
#Convert string to key
server_public_key = AES.importKey(server_string)
# print(server_public_key)

#Encrypt message and send to server
encrypted = server_public_key.encrypt(message, 32)

s.sendall(encrypted)
s.close()  