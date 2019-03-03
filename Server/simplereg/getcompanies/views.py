from django.shortcuts import render
from . import models
import json
from django.http import HttpResponse


def getcmp(request):
    response = {'aircompanies': []}
    if request.method == 'GET':
        companies = models.Companies.objects.all()
        for i in companies:
            response['aircompanies'].append({'name': i.name, 'id': i.companyID, 'logoURL': i.logoURL})
        return HttpResponse(json.dumps(response), content_type="application/json")
