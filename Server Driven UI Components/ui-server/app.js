const express = require('express')
const app = express()

app.get('/ui-list', (req, res) => {
    const model = {
        title: 'Cars',
        components: [
            {
                type: 'featureImage',
                data: {
                    imageUrl: 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                }
            }
        ]
    }
    res.json(model)
})

app.listen(3000, () => {
    console.log('Server is up and running')
})