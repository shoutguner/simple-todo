# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(
    email: 'email@email.com',
    provider: 'email',
    uid: 'email@email.com',
    password: 'password',
    password_confirmation: 'password'
)

Project.create(
        name: 'Complete the task for Ruby Garage',
        user_id: 1
)

Project.create(
        name: 'For home',
        user_id: 1
)

Task.create(
    text: 'First task',
    priority: 1,
    done: false,
    project_id: 1
)

Task.create(
    text: 'Second task',
    priority: 2,
    done: false,
    project_id: 1
)

Task.create(
    text: 'Third task',
    priority: 3,
    done: false,
    project_id: 1
)

Task.create(
    text: 'Fourth task',
    priority: 4,
    done: false,
    project_id: 1
)

Task.create(
    text: 'Buy a milk',
    priority: 5,
    done: false,
    project_id: 2
)

Task.create(
    text: 'Call Mom',
    priority: 6,
    done: false,
    project_id: 2
)

Task.create(
    text: 'Clean the room',
    priority: 7,
    done: false,
    project_id: 2
)

Task.create(
    text: 'Repair the DVD Player',
    priority: 8,
    done: false,
    project_id: 2
)

Comment.create(
    text: 'First comment',
    task_id: 8
)

Comment.create(
    text: 'Very-very long text of second comment to 8 task on second project.
           Very-very long text of second comment to 8 task on second project.',
    task_id: 8
)