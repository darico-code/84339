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

/*
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
*/

/* 28. Raggruppare per nome_squadra e calcolare la media punti fatta
e subita (solo nelle partite vinte (team0)) */

/*
db.games.aggregate([{$project: {'nome_squadra': {$getField:{field:'name', input:{$arrayElemAt: ["$teams", 0]}}}, 'score1': {$getField: {field: 'score', input: {$arrayElemAt: ["$teams", 0]}}}, 'score2': {$getField: {field:'score', input:{$arrayElemAt: ["$teams", 1]}}} }},
{$group: {'_id': '$nome_squadra', 'avg_point_made': {"$avg": "$score1"}, 'avg_point_taken': {"$avg": "$score2"}}}])
*/

/*
29. Contare il numero di partite giocate per ogni mese, anno
(ordinando il risultato su anno, mese)
*/

/*
console.log(db.games.aggregate
(
  [
    {
      $group:
      {
        '_id': {'anno': {$year: '$date'}, 'mese': {$month: '$date'}},
        'numPartite': {$sum: 1}
      }
    }
  ]
))*/

/*
30. Eseguire l’unwind dell’array teams e raggruppare per team per
ottenere il totale di: partite giocate, vinte, perse, punti segnati
*/

/*
console.log(db.games.aggregate(
  [
    {
      $unwind: 
      {path: "$teams"}
    },
    {
      $group: 
      { '_id': "$teams.name",
        'played_matches': {"$sum": 1},
        'pts_total': {"$sum": "$teams.score"},
        'matches_won': {"$sum": "$teams.won"},
      }
    }, {
      $addFields : {
        'matches_lost': {$subtract : ['$played_matches', '$matches_won']}
      }
    }

  ]
));
*/

/*
31. Eseguire l’unwind dell’array box e dell’array players, raggruppare
per player per ottenere il totale di punti segnati; ordinare il risultato
per visualizzare per primi i migliori giocatori del’NBA
*/

/*
console.log(db.games.aggregate(
  [
    { $unwind: 
      { path: '$box' } 
    }, 
    { $unwind:
      {path: '$box.players'}
    },
    {
      $group: 
      {
        '_id': '$box.players.player',
        'total_points': {"$sum": '$box.players.pts'}
      }
    },
    {
      $sort: {'total_points': -1}
    }
  ]
))*/

// Usare anche la collezione nba2016_players

/*
32. Unire la collection games con la collection nba2016_players ed
escludere i giocatori per cui non sono state trovati riferimenti (N.B.:
se non ci sono riferimenti, il nuovo campo sarà un array vuoto)



console.log(db.games.aggregate(
  [
    {$lookup:{from: "nba2016players", localField : "box.players.player", foreignField: "name", as: "nba2016dati"}},
    {$match :{$expr:{$gt: [{$size: "$nba2016dati"}, 0]}}}
  ]
))
*/

/*
33. Estendere la query precedente per visualizzare il nome del
giocatore, il totale di punti fatti ed il valore suo contratto (contract.amount)
*/
/*
console.log(db.games.aggregate(
  [
    {$lookup:{from: "nba2016players", localField : "box.players.player", foreignField: "name", as: "nba2016dati"}},
    {$match :{$expr:{$gt: [{$size: "$nba2016dati"}, 0]}}},
    {$project: {"name": "$nba2016dati.name", "points_made": {$getField: {field: 'pts', input: {$arrayElemAt: [{$arrayElemAt: ["$nba2016dati.stats", 0]}, 0]}}},
               "contract_values": "$nba2016dati.contract.amount"}}
  ]
))
*/