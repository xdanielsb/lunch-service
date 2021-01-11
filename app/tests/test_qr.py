from app.control.services import generate_qr_image


def test_generate_image():
    id_ticket = 10
    img = generate_qr_image(id_ticket)
    print(img)
