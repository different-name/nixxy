import WebSocket from 'ws';
import * as flatbuffers from 'flatbuffers';
import {
  MessageBundleT,
  RpcMessageHeaderT,
  ResetRequestT,
  ResetType,
  RpcMessage,
} from './SolarXR-Protocol-ts/all_generated';

const arg = process.argv[2]?.toLowerCase();
if (!arg || !['yaw', 'full', 'mounting'].includes(arg)) {
  console.error('Usage: slimevr-cli <yaw|full|mounting>');
  process.exit(1);
}

const resetTypeMap: Record<string, ResetType> = {
  yaw: ResetType.Yaw,
  full: ResetType.Full,
  mounting: ResetType.Mounting,
};

const rt = resetTypeMap[arg];

async function runReset() {
  return new Promise<void>((resolve, reject) => {
    const ws = new WebSocket('ws://localhost:21110');

    ws.on('open', () => {
      const resetReq = new ResetRequestT();
      resetReq.resetType = rt;

      const rpcHeader = new RpcMessageHeaderT();
      rpcHeader.messageType = RpcMessage.ResetRequest;
      rpcHeader.message = resetReq;

      const bundleT = new MessageBundleT();
      bundleT.rpcMsgs = [rpcHeader];

      const builder = new flatbuffers.Builder(64);
      const offset = bundleT.pack(builder);
      builder.finish(offset);
      const bytes = builder.asUint8Array();

      ws.send(bytes);
    });

    ws.on('message', (data) => {
      ws.close();
      resolve();
    });

    ws.on('error', (err) => {
      console.error('WebSocket error:', err);
      reject(err);
    });
  });
}

runReset()
  .then(() => process.exit(0))
  .catch(() => process.exit(2));
