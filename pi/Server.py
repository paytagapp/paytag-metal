import socket
import threading

class Server(object):
    """
    Simple TCP server.
    """
    def __init__(self, server_address, server_port, on_data=None):
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)  # Reuse the address
        self.server_address = server_address
        self.server_port = server_port
        self.on_data = on_data if on_data else lambda data, addr: print(f"Received data from {addr}: {data.decode()}")

    def handle_client(self, client_socket, client_address):
        with client_socket:
            while True:
                data = client_socket.recv(1024)
                if not data:
                    break
                self.on_data(data, client_address)

    def start_server(self):
        hostname = socket.gethostname()
        ip_address = socket.gethostbyname(hostname)
        print("Server is running on: ")
        print(ip_address)
        # Bind the socket to the address and port
        self.server_socket.bind((self.server_address, self.server_port))

        # Listen for incoming connections
        self.server_socket.listen()
        print(f"Server listening on {self.server_address}:{self.server_port}")

        # Accept connections and handle them
        while True:
            client_socket, client_address = self.server_socket.accept()
            client_handler = threading.Thread(target=self.handle_client,
                                              args=(client_socket, client_address))
            client_handler.start()

    def close_server(self):
        print("Closing server")
        self.server_socket.close()

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close_server()


