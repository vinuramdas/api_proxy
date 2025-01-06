# ...

resource "aws_sfn_state_machine" "sfn_api_lambda" {
  name     = "sfn_api_lambda"
  role_arn = "arn:aws:iam::247943787530:role/service-role/StepFunctions-MyStateMachine-030lmi2zq-role-fszvp4qv6"
  publish  = true
  //type     = "EXPRESS"

  definition = <<EOF
{
  "QueryLanguage": "JSONata",
  "Comment": "A description of my state machine",
  "StartAt": "api proxy Lambda Invoke",
  "States": {
    "api proxy Lambda Invoke": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Output": "{% $states.result.Payload %}",
      "Arguments": {
        "FunctionName": "arn:aws:lambda:us-east-1:247943787530:function:api_proxy:$LATEST",
        "Payload": "{% $states.input %}"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 1,
          "MaxAttempts": 3,
          "BackoffRate": 2,
          "JitterStrategy": "FULL"
        }
      ],
      "End": true
    }
  }
}
EOF
}