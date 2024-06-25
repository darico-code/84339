/*
23. Restituire (in campi separati) l’anno, il mese ed il giorno di ogni
partita
*/

//console.log(db.games.aggregate([{$project: {"Anno": {"$year": "$date"}, "_id": 0, "Mese": {"$month": "$date"}, "Giorno": {"$dayOfMonth": "$date"}}}]))

/*
24. Restituire un campo che indichi quanti anni fa è stata disputata
ciascuna partita (sottrarre l’anno di new Date() dall’anno della partita)
*/

// console.log(db.games.aggregate([{$project: {"Anni passati": {"$subtract": [{"$year": new Date()}, {"$year":"$date"}]}, "_id": 0}}]))

/*
25. Restituire l’anno, il mese ed il giorno di ogni partita e i nomi delle
2 squadre
*/

/*
console.log(db.games.aggregate([{$project: 
                                {"Anno": {"$year": "$date"},
                                "_id": 0,
                                "Mese": {"$month": "$date"},
                                "Giorno": {"$dayOfMonth": "$date"},
                                "Squadra1": {$getField: {field: "name", input: {$arrayElemAt: ["$teams", 0]}}},
                                "Squadra2": {$getField: {field: "name", input: {$arrayElemAt: ["$teams", -1]}}}}}]))
*/

/*
26. Restituire, per ogni partita: i due team, il rispettivi punti e la
differenza tra i punteggi delle due squadre 
*/

/*
console.log(db.games.aggregate([{$project: 
    {"_id": 0,
    "Punti squadra1": {$getField: {field: "score", input: {$arrayElemAt: ["$teams", 0]}}},
    "Punti squadra2": {$getField: {field: "score", input: {$arrayElemAt: ["$teams", -1]}}},
    "Differenza Punteggi": {$abs: {$subtract : [{$getField: {field: "score", input: {$arrayElemAt: ["$teams", -1]}}}, {$getField: {field: "score", input: {$arrayElemAt: ["$teams", 0]}}}]}},
    "Squadra1": {$getField: {field: "name", input: {$arrayElemAt: ["$teams", 0]}}},
    "Squadra2": {$getField: {field: "name", input: {$arrayElemAt: ["$teams", -1]}}}}}]))
*/

/*
27. Data la query precedente, filtrare solo le partite in cui la
differenza è di un unico punto e in cui ha vinto la squadra di casa (la
squadra che ha vinto è il team1)
*/


console.log(db.games.aggregate([
    {
      $project: {
        "_id": 0,
        "Punti squadra1": { $getField: { field: "score", input: { $arrayElemAt: ["$teams", 0] } } },
        "Punti squadra2": { $getField: { field: "score", input: { $arrayElemAt: ["$teams", -1] } } },
        "Differenza Punteggi": {
          $abs: {
            $subtract: [
              { $getField: { field: "score", input: { $arrayElemAt: ["$teams", -1] } } },
              { $getField: { field: "score", input: { $arrayElemAt: ["$teams", 0] } } }
            ]
          }
        },
        "Squadra1": { $getField: { field: "name", input: { $arrayElemAt: ["$teams", 0] } } },
        "Squadra2": { $getField: { field: "name", input: { $arrayElemAt: ["$teams", -1] } } }
      }
    },
    {
      $match: {
        $and: [
          { "Differenza Punteggi": 1 },
          { $expr: { $gt: ["$Punti squadra1", "$Punti squadra2"] } }
        ]
      }
    }
  ])
)
