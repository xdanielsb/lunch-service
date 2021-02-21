import base64
from io import BytesIO

import qrcode
from flask_mail import Message

from .. import mail


def send_email(subject, recipient, message):
    msg = Message(
        "Bienvendio a el sistema de apoyo alimentario.", recipients=[recipient]
    )
    msg.body = message
    mail.send(msg)
    return True


def generate_qr_image(id_ticket, id_student):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(str(id_student))
    qr.make(fit=True)
    image = qr.make_image(fill_color="black", back_color="white")
    buffered = BytesIO()
    image.save(buffered, format="JPEG")
    return base64.encodebytes(buffered.getvalue()).decode("ascii")
