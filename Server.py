import http.server
import socketserver

PORT = 9999

class RequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # 1. Extraemos y mostramos las coordenadas en consola inmediatamente
        if "lat=" in self.path:
            print(f"\033[1;32m[+] UBICACIÓN EN TIEMPO REAL: {self.path}\033[0m")
        else:
            print(f"\033[1;34m[*] Solicitud de sistema: {self.path}\033[0m")

        # 2. Enviamos la respuesta con la instrucción de refresco (cada 5 segundos)
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.send_header("Refresh", "5")  # <--- Esto fuerza el reporte constante
        self.end_headers()
        
        # 3. Respuesta visual para el operativo (o el sistema de rastreo)
        response_html = f"<html><body><h1>GEO-AUTO TRACKING ACTIVE</h1><p>Intervalo: 5s</p></body></html>"
        self.wfile.write(response_html.encode())

# Permitir reiniciar el servidor sin esperar al sistema operativo
socketserver.TCPServer.allow_reuse_address = True

print(f"\033[1;33m=================================================\033[0m")
print(f"\033[1;32m[*] MODO RASTREO ACTIVO - PUERTO {PORT}\033[0m")
print(f"\033[1;32m[*] Intervalo de actualización: 5 segundos\033[0m")
print(f"\033[1;33m=================================================\033[0m")

with socketserver.TCPServer(("", PORT), RequestHandler) as httpd:
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n[!] Deteniendo rastreo seguro...")
        httpd.shutdown()
