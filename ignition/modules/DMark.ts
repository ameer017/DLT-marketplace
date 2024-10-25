// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";



const DMARKModule = buildModule("DmarkModule", (m) => {

  const dMark = m.contract("DMark");

  return { dMark };

});

export default DMARKModule;