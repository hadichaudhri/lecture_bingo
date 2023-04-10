# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LectureBingo.Repo.insert!(%LectureBingo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

LectureBingo.Repo.insert!(%LectureBingo.Incidents.Incident{title: "Boring
Animation", description: "The professor thought the animation was going to
helpfully illustrate a concept, but it was vague and unhelpful"})

LectureBingo.Repo.insert!(%LectureBingo.Incidents.Incident{title: "J'accuse
Coward", description: "The professor is blatenly called a coward by one of
their students"})

LectureBingo.Repo.insert!(%LectureBingo.Incidents.Incident{
  title: "Language!",
  description: "The professor yet again uses language heretofor not uttered in
the hallowed Duke lecture halls"
})

LectureBingo.Repo.insert!(%LectureBingo.Incidents.Incident{title: "Imposter
Syndrome", description: "The professor fails to answer a real-world question
for which 10 students in the class already know the answer"})

LectureBingo.Repo.insert!(%LectureBingo.Incidents.Incident{title: "Switching
Costs", description: "The professor takes at least 3 minutes switching from
slides to coding, all the while blaming his A/V environment rather than his
meager skills"})

LectureBingo.Repo.insert!(%LectureBingo.Incidents.Incident{title: "Slide
Surprise", description: "The professor clearly did not review his slides
prior to class and is constantly saying things aloud not realizing they will
appear on the slide just seconds later"})
