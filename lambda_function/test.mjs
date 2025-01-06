//import {validate_event} from '../lamda_layer/validate_input.mjs'
import {validate_event} from 'validation'
const event = {
    "key1": "value1",
    "key2": "value2",
    "key3": "value3",
    "request_type": "ani_lookup",
    "number": 10
  }

function square(x) {
    return new Promise((resolve) => {
            resolve(Math.pow(x, 2));
    });
}

// async function output(x) {
//     const ans = await square(x);
//     console.log(ans);
// }

//output(10);

export const myhandler = async (event) => {
    if (validate_event(event)) {
        const ans = await square(event.number);
        //console.log(ans);
        return ans;
    }
    else 
        return 0;
}

console.log(myhandler (event));