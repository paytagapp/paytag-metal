import { deepParseJson } from "deep-parse-json";
import { makeObservable, action, observable } from "mobx"
import { w3cwebsocket as WebSocketClient } from "websocket";

type ServerStateType = {
    cart: string[]
    has_cart: boolean
    tag_dict: Record<string, {
        count: number
        last_read: number
        id: string
    }>
    last_server_result?: any
}
class ServerState {
    data: ServerStateType = {
        cart: [],
        has_cart: false,
        tag_dict: {}
    }
    client: WebSocketClient;
    lastMessage?: Date;
    connectionState?: string

    constructor() {
        makeObservable(this, {
            data: observable,
            handleMessage: action,
            client: observable,
            lastMessage: observable,
            connectionState: observable
        })
        this.client = new WebSocketClient('ws://paytag1:8000');
        this.connectionState = 'connecting';
        this.client.onerror = () => {
            console.log('Connection Error');
            setTimeout(() => {
                this.client = new WebSocketClient('ws://paytag1:8000');
                console.log('Reconnecting...');
            }, 5000);
            this.connectionState = 'error';
        };
        
        this.client.onopen = () => {
            console.log('WebSocket Client Connected');
            this.connectionState = 'connected';
        };
        
        this.client.onclose =  () => {
            console.log('echo-protocol Client Closed');
            this.connectionState = 'closed';
        };
        
        this.client.onmessage = (e) => {
            if (typeof e.data === 'string') {
                this.handleMessage(e.data);
            }

            this.lastMessage = new Date();
        };


        this.client.onclose = () => {
            setTimeout(() => {
                this.client = new WebSocketClient('ws://paytag1:8000');
                console.log('Reconnecting...');
            }, 5000);
        };


    }

    handleMessage(message: string) {
        this.data = deepParseJson(message);
        console.log(deepParseJson(message));
                
    }
}


export const serverState = new ServerState();
