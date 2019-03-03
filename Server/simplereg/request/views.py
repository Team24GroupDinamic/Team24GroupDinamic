from django.shortcuts import render
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
import json
from getcompanies.models import Companies
from lib import main


@csrf_exempt
def req(request):
    if request.method == 'POST':
        jsonrequest = json.loads(request.body.decode("utf-8"))
        company = Companies.objects.get(companyID=jsonrequest["aircompanyId"])
        response = getattr(main, company.handler)(jsonrequest["surname"], jsonrequest["registrationNumber"], company.requestURL, company.reg)
        return HttpResponse(response, content_type="application/json")