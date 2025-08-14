from fastapi import FastAPI
from .routers import todos

app = FastAPI(title="Swarm Todo API")
app.include_router(todos.router)

@app.get("/healthz")
def health():
    return {"status": "ok"}
