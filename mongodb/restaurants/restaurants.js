/*10. Mostrare tutti i ristoranti esclusi quelli che si trovano a Brooklyn o nel Bronx*/

//console.log(db.restaurants.find({"borough": {$nin: ["Brooklyn", "Bronx"]}}))

/* 11. Mostrare i campi restaurant_id, name, borough e cuisine di tutti i documenti nella collezione. */

//console.log(db.restaurants.find({}, {"_id":0, restaurant_id": 1, "name":1, "borough":1, "cuisine":1}))

/*
12. Mostrare restaurant_id, name, borough e cuisine (escludere _id)
di un ristorante che si trova a Queens
*/

/*console.log(db.restaurants.findOne({"borough": "Queens"},
             {"_id": 0, "restaurant_id": 1, "name":1, "borough":1, "cuisine":1}))*/

// 13. Mostrare i primi 5 ristoranti che si trovano nel Bronx

// console.log(db.restaurants.find({"borough": "Bronx"}).limit(5))

/* 
14. Mostrare i prossimi 5 (escludendo i primi 5) ristoranti che si
trovano nel Bronx
*/

// console.log(db.restaurants.find({"borough": "Bronx"}).skip(5).limit(5))

/*
15. Mostrare restaurant_id, name, borough e cuisine per tutti i
ristoranti il cui nome inizia con 'Wil'
*/

// console.log(db.restaurants.find({"name": {$regex: /^Wil/}}, {"_id": 0, "restaurant_id": 1, "name":1, "borough":1, "cuisine":1}))