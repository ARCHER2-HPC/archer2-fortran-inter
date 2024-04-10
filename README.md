<img src="./img/archer2_logo.png" align="left" width="284" height="80" />
<img src="./img/epcc_logo.png" align="right" width="248" height="66"
    style="margin-top: 10px;" />

<br /><br /><br /><br />

# Intermediate Modern Fortran

[![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

Fortran (a contraction of Formula Translation) was the first programming
language to have a standard (in 1954), but has changed significantly
over the years. More recent standards (the latest being Fortran 2018) come
under the umbrella term "Modern Fortran". Fortran retains very great
significance in many areas of scientific and numerical computing,
particularly for applications such as quantum chemistry, plasmas, engineering
and fluid dynamics, and in numerical weather prediction and climate models.

This intermediate course concentrates on some of the more recent
features which are central to Modern Fortran. Attendees should be familiar
with the basics of Fortran programming which might be covered in an
introductory course, e.g., the one at,

https://github.com/ARCHER2-HPC/archer2-fortran-intro

So, attendees should be comfortable writing structured Fortran programs
based on modules and procedures, and have a sound grounding in variables,
logic, flow-of-control, and so on. Some knowledge of Fortran I/O is assumed.

There are two main topics in this intermediate course: the facilities in
Fortran for abstraction and polymorphism provided by classes and
interfaces, and the facilities for formal
interoperability with ANSI C. The course will cover type extension
("classes" and "inheritance"), type-bound procedures ("methods"),
generic procedures ("polymorphism"), and so on. The standard `iso_c_binding`
module provides facilities for interoperability with C; this allow the
communication of Fortran entities with direct analogues C, and also Fortran
objects (particularly arrays) which have no direct analogue in C.

Further language features concerning arrays, pointers, and facilities for
structured programming using submodules will also be covered along the way.

Knowledge of the object-oriented paradigm would be useful, but is not essential.
Knowledge of C is required for the material on C/Fortran interoperation. The
course will allow programmers interested in working on larger, structured,
software projects to make use of (almost) a full complement of Modern Fortran
features.

The course requires a Fortran compiler, for which a local machine or laptop
may be appropriate [1]. If you do not have access to a Fortran compiler,
course training accounts on ARCHER2 will be available which provide access
to various compilers. Use of a text editor will be required (some may prefer
an IDE, but we do not intend to consider or support IDEs).

[1] This may typically be `gfortran`, freely available as part of the
GNU Compiler Collection (GCC).
See e.g., https://gcc.gnu.org/wiki/GFortranBinaries

## Installation

For details of how to log into an ARCHER2 account, see [the ARCHER2 Quickstart for users.](https://docs.archer2.ac.uk/quick-start/quickstart-users/)

Check out the git repository to your laptop or ARCHER2 account.
```bash
$ git clone https://github.com/ARCHER2-HPC/archer2-fortran-inter.git
```
The default Fortran compiler on ARCHER2 is the Cray Fortran compiler invoked using `ftn`.
For example,
```bash
$ cd section-1.01
$ ftn example1.f90
```
should generate an executable with the default name `a.out`.

Each section of the course is associated with a different directory, each of which
contains a number of example programs and exercise templates. Answers to exercises
generally re-appear as templates to later exercises. Miscellaneous solutions also
appear in the solutions directory.

Not all the examples compile. Some have deliberate errors which will be discussed
as part of the course.


## Timetable

This is a two-day course.

### Day One

| Time  | Content                                                 | Section                      |
|-------|---------------------------------------------------------|------------------------------|
| 09:30 | Logistics: login, compiler set-up, local details        | None                         |
|       | See above                                               |                              |
| 10:00 | Arrays: recap                                           |                              |
|       | declarations, sections, constructors, `allocatable`     | [section-1.01](section-1.01) |
| 10:20 | Arrays as arguments                                     |                              |
|       | assumed shape, restrictions on arguments, ...           | [section-1.02](section-1.02) |
| 10:40 | Pointers and procedures                                 |                              |
|       | `pointer`, `target`, `contiguous`, procedure pointers   | [section-1.03](section-1.03) |
| 11:00 | Break                                                   |                              |
|       |                                                         |                              |
| 11:30 | Derived types                                           |                              |
|       | `type`, components, assignments and copying             | [section-2.01](section-2.01) |
| 11:50 | Interfaces and generic procedures                       |                              |
|       | `interface`, `operator`                                 | [section-2.02](section-2.02) |
| 12:20 | Type extension and polymorphism                         |                              |
|       | `type, extends(...)`, `class`                           | [section-2.03](section-2.03) |
| 12:40 | Type-bound procedures                                   |                              |
|       | `contains` `procedure`, `pass`, `generic`               | [section-2.04](section-2.04) |
| 13:00 | Lunch                                                   |                              |
| 14:00 | Input/output for types                                  |                              |
|       | `write(formatted)`                                      | [section-3.01](section-3.01) |
| 15:00 | Break                                                   |                              |
| 15:30 | Interfaces and abstract types                           |                              |
|       | `type, abstract`, `deferred`                            | [section-4.01](section-4.01) |
| 17:00 | Close                                                   |                              |

### Day Two

| Time  | Content                                                 | Section                      |
|-------|---------------------------------------------------------|------------------------------|
| 09:30 | Submodules                                              |                              |
|       | `module`, `submodule`                                   | [section-5.01](section-5.01) |
| 10:10 | Unlimited polymorphic entities                          |                              |
|       | `class (*)`, typed allocations                          | [section-5.02](section-5.02) |
| 11:00 | Break                                                   |                              |
| 11:30 | Type parameters                                         | [section-6.01](section-6.01) |
|       | `kind`, `len`                                           |                              |
| 11:50 | Intrinsic modules                                       |                              |
|       | `iso_fortran_env`, `ieee_exceptions`, `ieee_arithmetic`|                              |
| 12:10 | Interoperability with C                                 |                              |
|       | `iso_c_binding`                                         |                              |
| 13:00 | Lunch                                                   |                              |
| 14:00 | ...                                                     |                              |
| 15:00 | Break                                                   |                              |
| 15:20 | Exercises                                               |                              |
|       |                                                         |                              |
| 15:40 | Closing statements                                      |                              |
| 16:00 | Close                                                   |                              |

---
This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]