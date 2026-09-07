import socket, threading

def pipe(a, b):
    try:
        while True:
            d = a.recv(65536)
            if not d: break
            b.sendall(d)
    except OSError: pass
    finally:
        try: b.shutdown(socket.SHUT_WR)
        except OSError: pass

def serve(family, addr):
    srv = socket.socket(family, socket.SOCK_STREAM)
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    if family == socket.AF_INET6:
        srv.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY, 1)
    srv.bind((addr, 41595))
    srv.listen(64)
    print(f'relay on {addr}:41595 -> 127.0.0.1:41593', flush=True)
    while True:
        c, _ = srv.accept()
        try:
            u = socket.create_connection(('127.0.0.1', 41593), timeout=5)
        except OSError:
            c.close(); continue
        threading.Thread(target=pipe, args=(c, u), daemon=True).start()
        threading.Thread(target=pipe, args=(u, c), daemon=True).start()

threading.Thread(target=serve, args=(socket.AF_INET, '127.0.0.1'), daemon=True).start()
serve(socket.AF_INET6, '::1')
