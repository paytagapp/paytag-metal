import json
import urllib.request

class PaytagServer:
    @staticmethod
    def findPaidCartWithItems(ids):
        url = "https://dev01api.paytagapp.com/verify_cart_payment"
        query_params = ",".join([f"{id}" for id in ids])
        url = url + "?" + query_params
        print(url)
        request = urllib.request.Request(url, None, method='POST')
        data = urllib.request.urlopen(request).read()
        obj = json.loads(data.decode())
        return obj

if __name__ == "__main__":
    ids = ["E2806995000040037312A93A", "E2806995000040037312AD3A", "E2806995000040037312B13A"]
    result = PaytagServer.findPaidCartWithItems(ids)
    print(result)

