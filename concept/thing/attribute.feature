# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

#noinspection CucumberUndefinedStep
Feature: Concept Attribute

  Background:
    Given typedb starts
    Given connection opens with default authentication
    Given connection has been opened
    Given connection does not have any database
    Given connection create database: typedb
    Given connection open schema session for database: typedb
    Given session opens transaction of type: write
    # Write schema for the test scenarios
    Given put attribute type: is-alive, with value type: boolean
    Given put attribute type: age, with value type: long
    Given put attribute type: score, with value type: double
    Given put attribute type: birth-date, with value type: datetime
    Given put attribute type: name, with value type: string
    Given put attribute type: email, with value type: string
    Given attribute(email) as(string) set regex: \S+@\S+\.\S+
    Given put entity type: person
    Given entity(person) set owns attribute type: is-alive
    Given entity(person) set owns attribute type: age
    Given entity(person) set owns attribute type: score
    Given entity(person) set owns attribute type: name
    Given entity(person) set owns attribute type: email
    Given entity(person) set owns attribute type: birth-date
    Given transaction commits
    Given connection close all sessions
    Given connection open data session for database: typedb
    Given session opens transaction of type: write
    Given set time-zone is: Europe/London

  Scenario: Attribute with value type boolean can be created
    When $x = attribute(is-alive) as(boolean) put: true
    Then attribute $x is null: false
    Then attribute $x has type: is-alive
    Then attribute $x has value type: boolean
    Then attribute $x has boolean value: true
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(is-alive) as(boolean) get: true
    Then attribute $x is null: false
    Then attribute $x has type: is-alive
    Then attribute $x has value type: boolean
    Then attribute $x has boolean value: true

  Scenario: Attribute with value type long can be created
    When $x = attribute(age) as(long) put: 21
    Then attribute $x is null: false
    Then attribute $x has type: age
    Then attribute $x has value type: long
    Then attribute $x has long value: 21
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(age) as(long) get: 21
    Then attribute $x is null: false
    Then attribute $x has type: age
    Then attribute $x has value type: long
    Then attribute $x has long value: 21

  Scenario: Attribute with value type double can be created
    When $x = attribute(score) as(double) put: 123.456
    Then attribute $x is null: false
    Then attribute $x has type: score
    Then attribute $x has value type: double
    Then attribute $x has double value: 123.456
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(score) as(double) get: 123.456
    Then attribute $x is null: false
    Then attribute $x has type: score
    Then attribute $x has value type: double
    Then attribute $x has double value: 123.456

  Scenario: Attribute with value type string can be created
    When $x = attribute(name) as(string) put: alice
    Then attribute $x is null: false
    Then attribute $x has type: name
    Then attribute $x has value type: string
    Then attribute $x has string value: alice
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(name) as(string) get: alice
    Then attribute $x is null: false
    Then attribute $x has type: name
    Then attribute $x has value type: string
    Then attribute $x has string value: alice

  Scenario: Attribute with value type string and satisfies a regular expression can be created
    When $x = attribute(email) as(string) put: alice@email.com
    Then attribute $x is null: false
    Then attribute $x has type: email
    Then attribute $x has value type: string
    Then attribute $x has string value: alice@email.com
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(email) as(string) get: alice@email.com
    Then attribute $x is null: false
    Then attribute $x has type: email
    Then attribute $x has value type: string
    Then attribute $x has string value: alice@email.com

  Scenario: Attribute with value type string but does not satisfy a regular expression cannot be created
    When attribute(email) as(string) put: alice-email-com; throws exception

  Scenario: Attribute with value type datetime can be created
    When $x = attribute(birth-date) as(datetime) put: 1990-01-01 11:22:33
    Then attribute $x is null: false
    Then attribute $x has type: birth-date
    Then attribute $x has value type: datetime
    Then attribute $x has datetime value: 1990-01-01 11:22:33
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(birth-date) as(datetime) get: 1990-01-01 11:22:33
    Then attribute $x is null: false
    Then attribute $x has type: birth-date
    Then attribute $x has value type: datetime
    Then attribute $x has datetime value: 1990-01-01 11:22:33

  Scenario: Attribute with value type boolean can be retrieved from its type
    When $x = attribute(is-alive) as(boolean) put: true
    Then attribute(is-alive) get instances contain: $x
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(is-alive) as(boolean) get: true
    Then attribute(is-alive) get instances contain: $x

  Scenario: Attribute with value type long can be retrieved from its type
    When $x = attribute(age) as(long) put: 21
    Then attribute(age) get instances contain: $x
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(age) as(long) get: 21
    Then attribute(age) get instances contain: $x

  Scenario: Attribute with value type double can be retrieved from its type
    When $x = attribute(score) as(double) put: 123.456
    Then attribute(score) get instances contain: $x
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(score) as(double) get: 123.456
    Then attribute(score) get instances contain: $x

  Scenario: Attribute with value type string can be retrieved from its type
    When $x = attribute(name) as(string) put: alice
    Then attribute(name) get instances contain: $x
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(name) as(string) get: alice
    Then attribute(name) get instances contain: $x

  Scenario: Attribute with value type datetime can be retrieved from its type
    When $x = attribute(birth-date) as(datetime) put: 1990-01-01 11:22:33
    Then attribute(birth-date) get instances contain: $x
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(birth-date) as(datetime) get: 1990-01-01 11:22:33
    Then attribute(birth-date) get instances contain: $x

  Scenario: Datetime attribute can be inserted in one timezone and retrieved in another with no change in the value
    When set time-zone is: Asia/Calcutta
    When $x = attribute(birth-date) as(datetime) put: 2001-08-23 08:30:00
    Then attribute $x is null: false
    Then attribute $x has type: birth-date
    Then attribute $x has value type: datetime
    Then attribute $x has datetime value: 2001-08-23 08:30:00
    When transaction commits
    When session opens transaction of type: read
    When set time-zone is: America/Chicago
    When $x = attribute(birth-date) as(datetime) get: 2001-08-23 08:30:00
    Then attribute $x is null: false
    Then attribute $x has type: birth-date
    Then attribute $x has value type: datetime
    Then attribute $x has datetime value: 2001-08-23 08:30:00

  Scenario: Attribute with value type boolean can be deleted
    When $x = attribute(is-alive) as(boolean) put: true
    When delete attribute: $x
    Then attribute $x is deleted: true
    When $x = attribute(is-alive) as(boolean) get: true
    Then attribute $x is null: true
    When transaction commits
    When session opens transaction of type: write
    When $x = attribute(is-alive) as(boolean) get: true
    Then attribute $x is null: true
    When $x = attribute(is-alive) as(boolean) put: true
    When transaction commits
    When session opens transaction of type: write
    When $x = attribute(is-alive) as(boolean) get: true
    When delete attribute: $x
    Then attribute $x is deleted: true
    When $x = attribute(is-alive) as(boolean) get: true
    Then attribute $x is null: true
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(is-alive) as(boolean) get: true
    Then attribute $x is null: true

  Scenario: Attribute with value type long can be deleted
    When $x = attribute(age) as(long) put: 21
    When delete attribute: $x
    Then attribute $x is deleted: true
    When $x = attribute(age) as(long) get: 21
    Then attribute $x is null: true
    When transaction commits
    When session opens transaction of type: write
    When $x = attribute(age) as(long) get: 21
    Then attribute $x is null: true
    When $x = attribute(age) as(long) put: 21
    When transaction commits
    When session opens transaction of type: write
    When $x = attribute(age) as(long) get: 21
    When delete attribute: $x
    Then attribute $x is deleted: true
    When $x = attribute(age) as(long) get: 21
    Then attribute $x is null: true
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(age) as(long) get: 21
    Then attribute $x is null: true

  Scenario: Attribute with value type double can be deleted
    When $x = attribute(score) as(double) put: 123.456
    When delete attribute: $x
    Then attribute $x is deleted: true
    When $x = attribute(score) as(double) get: 123.456
    Then attribute $x is null: true
    When transaction commits
    When session opens transaction of type: write
    When $x = attribute(score) as(double) get: 123.456
    Then attribute $x is null: true
    When $x = attribute(score) as(double) put: 123.456
    When transaction commits
    When session opens transaction of type: write
    When $x = attribute(score) as(double) get: 123.456
    When delete attribute: $x
    Then attribute $x is deleted: true
    When $x = attribute(score) as(double) get: 123.456
    Then attribute $x is null: true
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(score) as(double) get: 123.456
    Then attribute $x is null: true

  Scenario: Attribute with value type string can be deleted
    When $x = attribute(name) as(string) put: alice
    When delete attribute: $x
    Then attribute $x is deleted: true
    When $x = attribute(name) as(string) get: alice
    Then attribute $x is null: true
    When transaction commits
    When session opens transaction of type: write
    When $x = attribute(name) as(string) get: alice
    Then attribute $x is null: true
    When $x = attribute(name) as(string) put: alice
    When transaction commits
    When session opens transaction of type: write
    When $x = attribute(name) as(string) get: alice
    When delete attribute: $x
    Then attribute $x is deleted: true
    When $x = attribute(name) as(string) get: alice
    Then attribute $x is null: true
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(name) as(string) get: alice
    Then attribute $x is null: true

  Scenario: Attribute with value type datetime can be deleted
    When $x = attribute(birth-date) as(datetime) put: 1990-01-01 11:22:33
    When delete attribute: $x
    Then attribute $x is deleted: true
    When $x = attribute(birth-date) as(datetime) get: 1990-01-01 11:22:33
    Then attribute $x is null: true
    When transaction commits
    When session opens transaction of type: write
    When $x = attribute(birth-date) as(datetime) get: 1990-01-01 11:22:33
    Then attribute $x is null: true
    When $x = attribute(birth-date) as(datetime) put: 1990-01-01 11:22:33
    When transaction commits
    When session opens transaction of type: write
    When $x = attribute(birth-date) as(datetime) get: 1990-01-01 11:22:33
    When delete attribute: $x
    Then attribute $x is deleted: true
    When $x = attribute(birth-date) as(datetime) get: 1990-01-01 11:22:33
    Then attribute $x is null: true
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(birth-date) as(datetime) get: 1990-01-01 11:22:33
    Then attribute $x is null: true

  Scenario: Attribute with value type double is assignable and retrievable from a 'long' value
    When $x = attribute(score) as(double) put: 123
    Then attribute $x is null: false
    Then attribute $x has type: score
    Then attribute $x has value type: double
    Then attribute $x has double value: 123
    When transaction commits
    When session opens transaction of type: read
    When $x = attribute(score) as(double) get: 123
    Then attribute $x is null: false
    Then attribute $x has type: score
    Then attribute $x has value type: double
    Then attribute $x has double value: 123

  Scenario: Attribute with value type boolean can be owned

  Scenario: Attribute with value type long can be owned

  Scenario: Attribute with value type double can be owned

  Scenario: Attribute with value type string can be owned

  Scenario: Attribute with value type datetime can be owned
