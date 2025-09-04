from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
import socket, os, getpass, datetime
from zoneinfo import ZoneInfo
import httpx

app = FastAPI(title="Simple FastAPI")


templates = Jinja2Templates(directory="templates")
app.mount("/static", StaticFiles(directory="static"), name="static")


@app.get("/")
async def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})


@app.get("/api/info", response_class=JSONResponse)
async def info():
    hostname = socket.gethostname()

    def get_local_ip():
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(("8.8.8.8", 80))
            ip = s.getsockname()[0]
        except Exception:
            try:
                ip = socket.gethostbyname(hostname)
            except Exception:
                ip = "Unavailable"
        finally:
            try:
                s.close()
            except Exception:
                pass
        return ip

    local_ip = get_local_ip()

    try:
        async with httpx.AsyncClient(timeout=3.0) as client:
            r = await client.get("https://api.ipify.org?format=json")
            r.raise_for_status()
            public_ip = r.json().get("ip", "Unavailable")
    except Exception:
        public_ip = "Unavailable"

    now = datetime.datetime.now(tz=ZoneInfo("Europe/Berlin")).isoformat(
        timespec="seconds"
    )

    return {
        "hostname": hostname,
        "local_ip": local_ip,
        "public_ip": public_ip,
        "current_time": now,
        "user": getpass.getuser(),
        "current_directory_name": os.path.basename(os.getcwd()),
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)
