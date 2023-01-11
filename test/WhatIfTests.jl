using CurricularAnalyticsDiff
using CurricularAnalytics
using Test

@testset "What If Tests" begin
    # test add course
    curr = read_csv("./files/SY-CurriculumPlan-BE25.csv")

    new_course_name = "BENG 114"
    new_course_credit_hours = 4.0 # defualt, you can change it to 1.0,2.0,3.0, etc
    prereqs = Dict("BENG 122A" => pre,
        "MATH 18" => pre,
        "MAE 140" => pre)
    dependencies = Dict("TE 2" => pre,
        "MAE 107" => pre,
        "CHEM 7L" => pre)

    new_curric = add_course(new_course_name, curr, new_course_credit_hours, prereqs, dependencies)
    errors = IOBuffer()
    @test isvalid_curriculum(new_curric, errors) == true
    @test length(curr.courses) + 1 == length(new_curric.courses)
    # test that the course has the right credit new_course_credit_hours
    @test course_from_name(new_course_name, new_curric).credit_hours == 4.0
    @test course_from_name(new_course_name, new_curric).name == "BENG 114"
    @test course_from_name(new_course_name, new_curric).requisites == Dict(course_from_name("BENG 122A", new_curric).id => pre,
        course_from_name("MATH 18", new_curric).id => pre,
        course_from_name("MAE 140", new_curric).id => pre,)
    # check that the dependencies have it as a prereq
    @test course_from_name(new_course_name, new_curric) in get_course_prereqs(course_from_name("TE 2", new_curric), new_curric)
    @test course_from_name(new_course_name, new_curric) in get_course_prereqs(course_from_name("MAE 107", new_curric), new_curric)
    @test course_from_name(new_course_name, new_curric) in get_course_prereqs(course_from_name("CHEM 7L", new_curric), new_curric)

    # check that it's not in the old curriculum
    @test course_from_name(new_course_name, curr) == nothing

    #= 
    -------------------------------------------------------
    Remove a course
    -------------------------------------------------------
    =#


end
