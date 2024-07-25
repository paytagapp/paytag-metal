import { observer } from "mobx-react-lite"
import { serverState } from "./ServerState"


const App = observer(() => {

  return (
    <div style={{width: '90vw', height: '90vh', display: 'flex', justifyContent: 'center', alignItems: 'center', flexDirection: 'column'}}>
      <h1>Paytag</h1>
      <div>
        <h2>{serverState.data?.cart?.length} items</h2>
        <h2>{serverState.data?.last_server_result?.status ? 'Burning' : 'Not burning'}</h2>
      </div>
      {Object.values(serverState.data?.tag_dict || {}).map((item) => (
        <div key={item.id}>
          {item.id} {serverState.data?.cart.includes(item.id) ? '(Stable)' : ''}
        </div>
      ))}
      <div style={{marginTop: '20px'}}>
        {serverState.lastMessage?.toLocaleString()} ({serverState.connectionState})
      </div>
      <textarea style={{marginTop: '20px', width: '40vw', height: '20vh'}} value={JSON.stringify(serverState.data?.last_server_result, null, 4)}>
        
      </textarea>
    </div>
  )
})

export default App
