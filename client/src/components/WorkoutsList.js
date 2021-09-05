import React, { useState, useEffect } from 'react'
import Workout from './Workout'
import NewWorkoutForm from './NewWorkoutForm'

const WorkoutsList = () => {
    const [workouts, setWorkouts] = useState([])

    useEffect(() => {
        fetch('/workouts')
            .then(resp => resp.json())
            .then(data => setWorkouts(data))
    }, [])

    const addWorkout = (data) => {
        const config = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        }
        fetch('/workouts', config)
            .then(resp => resp.json())
            .then(() => setWorkouts([...workouts, data]))
    }

    const workoutList = workouts.map((workout, index) => <Workout key={index} workout={workout} workouts={workouts} setWorkouts={setWorkouts} />)

    return (
        <div>
            <NewWorkoutForm addWorkout={addWorkout} />
            {workoutList}
        </div>
    )
}

export default WorkoutsList