import React, { FC } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { Button } from "@chakra-ui/react";
import Main from "./routes/main";

const App: FC = () => {
    return (
        <BrowserRouter>
            <Routes>
                <Route path="/" element={<Main />}></Route>
            </Routes>
        </BrowserRouter>
    );
};

export default App;
