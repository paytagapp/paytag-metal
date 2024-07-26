import json
import urllib.request
import urllib.error

class PaytagServer:
    @staticmethod
    def findPaidCartWithItems(tagIds, storeId=None, supplierId=None):
        url = "https://dev01api.paytagapp.com/verify_cart_payment"
        # url = "http://127.0.0.1:1337/verify_cart_payment"   
        body = {
            "tagIds": tagIds
        }
        
        # Adding storeId and supplierId if provided
        if storeId is not None:
            body["storeId"] = storeId
        
        if supplierId is not None:
            body["supplierId"] = supplierId
        
        # Converting body to JSON format
        json_data = json.dumps(body).encode('utf-8')
        
        request = urllib.request.Request(url, data=json_data, headers={'Content-Type': 'application/json'}, method='POST')
        
        try:
            data = urllib.request.urlopen(request).read()
            obj = json.loads(data.decode())
            return obj
        except urllib.error.HTTPError as e:
            print(f"HTTPError: {e.code} - {e.reason}")
            # Handle specific HTTP errors here if needed
            return {"status": False, "error": f"HTTPError: {e.code} - {e.reason}"}
        except urllib.error.URLError as e:
            print(f"URLError: {e.reason}")
            return {"status": False, "error": f"URLError: {e.reason}"}
        except Exception as e:
            print(f"General Exception: {e}")
            return {"status": False, "error": f"Exception: {e}"}













































# import json
# import urllib.request

# class PaytagServer:
#     @staticmethod
#     def findPaidCartWithItems(tagIds, storeId=None, supplierId=None):
#         url = "http://127.0.0.1:1337/verify_cart_payment"        
#         # url = "https://dev01api.paytagapp.com/verify_cart_payment"        
#         body = {
#             "tagIds": tagIds
#         }
        
#         # Adding storeId and supplierId if provided
#         if storeId is not None:
#             body["storeId"] = storeId
        
#         if supplierId is not None:
#             body["supplierId"] = supplierId
        
#         # Converting body to JSON format
#         json_data = json.dumps(body).encode('utf-8')
        
#         request = urllib.request.Request(url, data=json_data, headers={'Content-Type': 'application/json'}, method='POST')
#         data = urllib.request.urlopen(request).read()
#         obj = json.loads(data.decode())
#         return obj