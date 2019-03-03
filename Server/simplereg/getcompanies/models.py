from django.db import models


class Companies(models.Model):
    name = models.CharField(max_length=100)
    companyID = models.CharField(max_length=100)
    logoURL = models.CharField(max_length=100)
    requestURL = models.CharField(max_length=100)
    reg = models.CharField(max_length=100)
    handler = models.CharField(max_length=100)
