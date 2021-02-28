import base64
from io import BytesIO

import qrcode
from flask_mail import Message

from .. import mail


def send_email(subject, recipient, message):
    msg = Message(subject, recipients=[recipient])
    msg.html = message
    mail.send(msg)
    return True


def generate_qr_image(id_ticket, id_student, typet=None):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(
        "{}/registerticket/{}".format("https://74ae74bec499.ngrok.io", id_ticket)
    )
    qr.make(fit=True)
    image = qr.make_image(fill_color="black", back_color="white")
    buffered = BytesIO()
    image.save(buffered, format="JPEG")
    return base64.encodebytes(buffered.getvalue()).decode("ascii")
