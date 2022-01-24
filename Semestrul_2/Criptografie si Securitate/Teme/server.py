import socket

'''
A server has a bind() method which binds it to a specific ip and port so that it can listen to incoming requests on that ip and port.
This allows the server to listen to incoming connections.
And last a server has an accept() and a close() method.
The accept() method initiates a connection with the client and the close() method closes the connection with the client.
'''

# next create a socket object
s = socket.socket()
print("Socket-ul s-a facut cu succes")

# reserve a port on your computer in out case
port = 12345

# next bind to the port
# nu voi da un ip exact, ii dau un string empty care va face sa serverul sa primeasca cereri de la computerele de pe retea
s.bind(('', port))

print('socket binded to %s' %(port))

# put the socket into the listening node

s.listen(5)

print("socket-ul asculta")

# an infinite loop until we interrupt it or an error occurs
while True:
    # trebuie sa stabilesc conexiunea cu clientul
    c, addr = s.accept()

    # afisez ca mi s-a permis conexiunea
    print("Got connection from ", addr)

    # trimit un mesaj clientului
    c.send("Thank you for connecting")

    # inchid conexiunea cu clientul
    c.close()
    