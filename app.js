const express=require('express')
const mongoose=require('mongoose')
const app=express();
app.listen(8080,()=>{{
    console.log("app is listening");
}})
mongoose.connect('mongodb://127.0.0.1:27017/docker')
  .then(() => console.log('Connected!'));