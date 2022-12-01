public class SteamNetworkingSocketsTransport : NetworkTransport
public ulong ConnectToSteamID;
public SteamNetworkingConfigValue_t[] options = new SteamNetworkingConfigValue_t[0];
public override ulong ServerClientId => 0;
public override bool IsSupported



public override void DisconnectLocalClient()
public override void DisconnectRemoteClient(ulong clientId)

public override ulong GetCurrentRtt(ulong clientId)
public override NetworkEvent PollEvent(out ulong clientId, out ArraySegment<byte> payload, out float receiveTime)
public override void Send(ulong clientId, ArraySegment<byte> segment, NetworkDelivery delivery)

public override void Shutdown()

public override void Initialize(NetworkManager networkManager = null)
public override bool StartClient()
public override bool StartServer()


private class SteamConnectionData
private Callback<SteamNetConnectionStatusChangedCallback_t> c_onConnectionChange = null;
private HSteamListenSocket listenSocket;
private SteamConnectionData serverUser;
private readonly Dictionary<ulong, SteamConnectionData> connectionMapping = new Dictionary<ulong, SteamConnectionData>();
private readonly Queue<SteamNetConnectionStatusChangedCallback_t> connectionStatusChangeQueue = new Queue<SteamNetConnectionStatusChangedCallback_t>();
private bool isServer = false;

private void CloseP2PSessions()
private void OnConnectionStatusChanged(SteamNetConnectionStatusChangedCallback_t param)

private static IEnumerator Delay(float time, Action action)


A before B will call CreateListenSocketP2P this happens on "StartServer" for us

B can then call ConnectP2P targeting A (this for us is on StartClient)

When A polls for the messages and state k_ESteamNetworkingConnectionState_Connecting it should check if it should accept (or in our case just always accept) then of course call AcceptConnection to actually accept ... (see PollEvent in our transport)

When B or A polls for messages and state
k_ESteamNetworkingConnectionState_Connected store your connection info you will need it to talk to this user in the future (see line 182)

if A or B sees k_ESteamNetworkingConnectionState_ClosedByPeer or k_ESteamNetworkingConnectionState_ProblemDetectedLocally that is a disconnect so clean up

finally to actually get the message A or B should use ReceiveMessagesOnConnection that will give you the byte[] data that is to be used by your game to do stuff