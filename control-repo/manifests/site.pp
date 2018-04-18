#This section ensures that anything listed in Hiera under classes can be used as classification

$classes = lookup('classes', Array[String], 'unique')
$exclusions = lookup('class_exclusions', Array[String], 'unique')
$classification = $classes - $exclusions

$classification.include

node 'application.company.com' {
  include role::application
}
