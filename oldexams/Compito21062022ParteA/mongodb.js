/* 1 */

db.movies.updateMany(
    { title: 'Da wan'},
    { $addToSet : { 'genres' : {$each : ['Action', 'Sci-Fi']}}}
)


/* 2 */

console.log(db.movies.aggregate(
    [
        {
            $unwind: {
                path : '$genres'
            }
        },
        {
            $group: {
                '_id' : '$genres', 
                'num_films' : {$sum: 1},
                'lista_films' : {$addToSet: "$title"}
            }
        }, 
        {
            $sort: {'num_films': -1}
        }

    ]
))

/* 3 */

console.log(db.movies.aggregate(
    [
        {
            $match : {$and : [{$expr : {$gt : ['$year', 2000]}}, {'genres': 'Drama'}]}
        },
        {
            $project: {'nome film': '$title', 'rating': {$avg : ['$imdb.rating', '$tomato.rating']}}
        },
        {
            $sort: {'rating': -1}
        },
        {
            $limit: 10
        }

    ]
))