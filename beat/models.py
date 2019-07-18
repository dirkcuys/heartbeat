from django.db import models
from django.contrib.postgres.fields import JSONField

class HeartBeat(models.Model):
    identifier = models.CharField(max_length=64)
    created_at = models.DateTimeField(auto_now_add=True)
    meta = JSONField(null=True)
