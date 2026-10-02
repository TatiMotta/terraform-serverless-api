import json
import os
import uuid

import boto3


# Cliente do DynamoDB
dynamodb = boto3.resource("dynamodb")

# Nome da tabela vem da variável de ambiente da Lambda
TABLE_NAME = os.environ["DYNAMODB_TABLE_NAME"]

# Referência para a tabela
table = dynamodb.Table(TABLE_NAME)


def response(status_code, body):
    """
    Monta uma resposta HTTP padrão para o API Gateway.
    """
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(body)
    }


def lambda_handler(event, context):
    """
    Função principal da Lambda.
    Recebe eventos do API Gateway e executa a operação correspondente.
    """

    http_method = event.get("httpMethod")
    path_parameters = event.get("pathParameters") or {}

    # POST /products
    if http_method == "POST":
        body = json.loads(event.get("body") or "{}")

        name = body.get("name")
        price = body.get("price")

        if name is None or price is None:
            return response(
                400,
                {
                    "message": "name e price são obrigatórios"
                }
            )

        product_id = str(uuid.uuid4())

        item = {
            "id": product_id,
            "name": name,
            "price": price
        }

        table.put_item(Item=item)

        return response(201, item)

    # GET /products
    if http_method == "GET" and not path_parameters.get("id"):
        result = table.scan()

        return response(
            200,
            result.get("Items", [])
        )

    # GET /products/{id}
    if http_method == "GET" and path_parameters.get("id"):
        product_id = path_parameters["id"]

        result = table.get_item(
            Key={
                "id": product_id
            }
        )

        item = result.get("Item")

        if not item:
            return response(
                404,
                {
                    "message": "Produto não encontrado"
                }
            )

        return response(200, item)

    # DELETE /products/{id}
    if http_method == "DELETE" and path_parameters.get("id"):
        product_id = path_parameters["id"]

        result = table.get_item(
            Key={
                "id": product_id
            }
        )

        if "Item" not in result:
            return response(
                404,
                {
                    "message": "Produto não encontrado"
                }
            )

        table.delete_item(
            Key={
                "id": product_id
            }
        )

        return response(
            200,
            {
                "message": "Produto excluído com sucesso"
            }
        )

    return response(
        404,
        {
            "message": "Rota não encontrada"
        }
    )
