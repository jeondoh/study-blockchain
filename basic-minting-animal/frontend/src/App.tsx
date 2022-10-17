import React, { FC, useEffect, useState } from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Main from "./routes/main";
import Layout from "./components/layout";
import MyAnimal from "./routes/myAnimal";

const App: FC = () => {
  const [account, setAccount] = useState<String>("");
  const getAccount = async () => {
    try {
      if (window.ethereum) {
        const accounts = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        setAccount(accounts[0]);
      } else {
        alert("install metamask");
      }
    } catch (e) {
      console.log(e);
    }
  };

  useEffect(() => {
    getAccount();
  }, [account]);

  return (
    <BrowserRouter>
      <Layout>
        <Routes>
          <Route path="/" element={<Main account={account.toString()} />} />
          <Route
            path="my-animal"
            element={<MyAnimal account={account.toString()} />}
          />
        </Routes>
      </Layout>
    </BrowserRouter>
  );
};

export default App;
