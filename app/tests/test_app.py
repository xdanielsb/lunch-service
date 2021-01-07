import pytest

from app.app import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_login(client):
    response = app.test_client().get("/")
    assert response.status_code == 200
