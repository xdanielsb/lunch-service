from flask_mail import Message

from .. import mail


def send_email(subject, sender, recipient, message):
    msg = Message("Hello", sender=sender, recipients=[recipient])
    msg.body = message
    mail.send(msg)
    return True
