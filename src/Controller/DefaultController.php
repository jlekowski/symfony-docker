<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\JsonResponse;

class DefaultController
{
    public function index($appJson)
    {
        return new JsonResponse($appJson);
    }
}
