const express=require('express')
const app=express()
const cors=require('cors')
const bodyparser=require('body-parser')
require('dotenv').config('./')
app.use(cors({
    origin:'*',
    methods:['GET','POST','DELETE','UPDATE','PUT','PATCH']
}))
app.use(bodyparser())
app.use(bodyparser.json())
app.use(express.json())

const userrouter=require('./routes/user.route')
const shopkeeperrouter=require('./routes/shopkeeper.route')

require('./db/db')
app.get('/',(req,res)=>{
    res.send('heelo')
})
app.use('/api/user',userrouter)
app.use('/api/shopkeeper',shopkeeperrouter)
app.listen(3000,()=>{
    console.log('🎉🎉🎉 listening at 3000');
}) 