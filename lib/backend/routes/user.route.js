const express = require('express')
const { registercontroller, logincontroller, userdetailscontroller, addtransaction, getpiechart, gettransaction, editTransaction, getuserdetails, changepassword, changeusername, deletetransaction } = require('../controller/user.controller')
const { verifier } = require('../middlewares/jwtverify')
const router = express.Router()

router
    .route('/register')
    .post(registercontroller)

router
    .route('/login')
    .post(logincontroller)


router
    .route('/details')
    .post(verifier, userdetailscontroller)

router
    .route('/addtransaction')
    .post(verifier, addtransaction)

router
    .route('/getpiechart')
    .post(verifier, getpiechart)

router
    .route('/gettransactions')
    .post(verifier, gettransaction)

router
    .route('/edittransaction')
    .post(verifier, editTransaction)

router
    .route('/getdetails')
    .post(verifier, getuserdetails)

router
    .route('/changepassword')
    .post(verifier, changepassword)
router
    .route('/changeusername')
    .post(verifier, changeusername)
router
    .route('/deletetransaction')
    .post(verifier, deletetransaction)


module.exports = router