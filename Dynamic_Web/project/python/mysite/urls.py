from django.urls import path
from django.http import HttpResponse
from django.conf import settings

def home_view(request):
    html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Django Application</title>
        <style>
            body {{ font-family: Arial, sans-serif; margin: 40px; }}
            h1 {{ color: #28a745; }}
            .container {{ max-width: 800px; margin: 0 auto; }}
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Hello from Django!</h1>
            <p>This is a Django application deployed without Docker.</p>
            <p>Running on port: 8081 (via Nginx proxy)</p>
            <p>Django version: 4.2</p>
            <p>Debug mode: {settings.DEBUG}</p>
        </div>
    </body>
    </html>
    """
    return HttpResponse(html)

urlpatterns = [
    path('', home_view),
]
