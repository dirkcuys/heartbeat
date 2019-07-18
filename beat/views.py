from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

from .models import HeartBeat

import json
import logging

logger = logging.getLogger(__name__)

# Create your views here.
@csrf_exempt
def beat(request, identifier):
    data = None
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError as e:
            logger.exception('Could not load json body')

    HeartBeat.objects.create(identifier=identifier, meta=json.dumps(data))
    return JsonResponse({'status': 'ok'})


def graph(request, identifier):
    sequence = HeartBeat.objects.filter(identifier=identifier).order_by('created_at')
    map_beat = lambda b: {'created_at': b.created_at, 'meta': json.loads(b.meta)}
    resp_data = {
        'status': 'ok',
        'count': sequence.count(),
        'data': [map_beat(b) for b in sequence]
    }
    return JsonResponse(resp_data)
