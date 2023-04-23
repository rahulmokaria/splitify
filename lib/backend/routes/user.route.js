const express=require('express')
const {registercontroller, logincontroller,userdetailscontroller,addtransaction, getpiechart}=require('../controller/user.controller')
const { verifier } = require('../middlewares/jwtverify')
const router=express.Router()

router
.route('/register')
.post(registercontroller)

router
.route('/login')
.post(logincontroller)


router
.route('/details')
.post(verifier,userdetailscontroller)

router
.route('/addtransaction')
.post(verifier,addtransaction)

router
.route('/getpiechart')
.post(verifier,getpiechart)
module.exports=router