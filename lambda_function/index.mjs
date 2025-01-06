import soap from 'soap';
//const url = 'https://www.dataaccess.com/webservicesserver/NumberConversion.wso';
const url = 'http://www.dneonline.com/calculator.asmx?wsdl';

const event = {
    "key1": "value1",
    "key2": "value2",
    "key3": "value3",
    "request_type": "ani_lookup"
  }

// export const handler = async (event) => {
//     var api_response;
//     console.log("Starting...")
//     switch(event.request_type)
//     {
//         case "policy_lookup":
//             api_response = policy_lookup(event.request_type);
//             break;
//         case "ani_lookup":
//             //api_response = ani_lookup(event.request_type);;
//             api_response = await square(3);
//             break;
//         case "policy_lookup":
//             api_response = responseno_lookup(event.request_type);        
//     };
//     const response = {
//       statusCode: 200,
//       body: JSON.stringify('Hello from Lambda!'),
//       event: event,
//       api_response: api_response
//     };
//     return response;
// };

export const handler = async (event) => {
    const ans = await square(event);
    console.log(ans);
}

console.log(handler(event));

function policy_lookup(request)
{
    return request;
}
function ani_lookup(request)
{
    var sum = 0;
    soap.createClient(url, function(err, client) {
        if (err) {
            console.error(err);
        } else {
            const args = { intA: 2, intB: 19 };
            client.Add(args, function (err, result) {
                    if (err) {
                        console.error(err);
                    } else {
                        sum=result;
                        console.log(result);
                    }
                });
        }
    });
    return sum;
}

// function square(x) {
//     return new Promise ((resolve) => {
//         Math.pow(x, 2)
//     });
// }

function square(x) {
    return new Promise((resolve) => {
            resolve(Math.pow(x, 2));
    });
}

function no_lookup(request)
{
    return request;
}