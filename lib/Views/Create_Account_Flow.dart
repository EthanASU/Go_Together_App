import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/Create_Account_Flow_View_Model.dart';
import '../Widgets/dashed_line_painter.dart';
import '../Widgets/arrow_painter.dart';

class CreateAccountFlowScreen extends StatelessWidget {
  const CreateAccountFlowScreen({super.key});

  Widget buildArrow(Color color) {
    return CustomPaint(
      size: const Size(50, 30),
      painter: ArrowPainter(color: color),
    );
  }

  Widget buildDashedLine(Color color) {
    return SizedBox(
      width: 40,
      child: CustomPaint(
        painter: DashedLinePainter(color: color),
      ),
    );
  }

  Widget buildProgressIndicator(BuildContext context) {
    final viewModel = context.watch<CreateAccountFlowViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        7,
        (index) {
          if (index % 2 == 0) {
            int arrowIndex = index ~/ 2;
            return buildArrow(viewModel.getArrowColor(arrowIndex));
          } else {
            return buildDashedLine(viewModel.getArrowColor(index ~/ 2));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateAccountFlowViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              buildProgressIndicator(context),
              const SizedBox(height: 40),
              Text(
                viewModel.pageHeaders[viewModel.currentStep].header,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (viewModel.currentStep == 0) ...[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Image.asset(
                        'Assets/go_together_logo.png',
                        height: 100,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Let's get started",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "I am a",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Parent option
                      RadioListTile<String>(
                        value: "parent",
                        groupValue: viewModel.selectedRole,
                        onChanged: (value) {
                          viewModel.setRole(value!);
                        },
                        title: const Text(
                          "Parent",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 100),
                      ),
                      // Student Option
                      RadioListTile<String>(
                        value: "student",
                        groupValue: viewModel.selectedRole,
                        onChanged: (value) {
                          viewModel.setRole(value!);
                        },
                        title: const Text(
                          "Student",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 100),
                      ),
                    ],
                  ),
                ),
              ] else if (viewModel.currentStep == 1) ...[
                Spacer(),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Select your school.',style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 45,
                        width: 250,
                        child: DropdownButtonFormField<String>(
                          value: viewModel.selectedSchool,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          onChanged: (newValue) {
                            viewModel.selectSchool(newValue);
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                "-Select School-",
                                style: const TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                              ),
                            ),
                            ...viewModel.schools.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Spacer(),
              ] else if (viewModel.currentStep == 2) ...[
                Spacer(),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'First name',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: viewModel.updateFirstName,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Last name',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: viewModel.updateLastName,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Student ID                                                                       ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: viewModel.updateStudentNumber,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Email address                                                               ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: viewModel.updateEmailAddress,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Phone number                                                                ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: viewModel.updatePhoneNumber,
                    ),
                  ],
                ),
                Spacer(),
              ] else if (viewModel.currentStep == 3) ...[
                const SizedBox(height: 20),
                Text(
                  "Welcome, ${viewModel.firstName}!",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your studenID was successfully matched in the system",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Create your password",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: viewModel.updatePassword,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Confirm Password',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: viewModel.updateConfirmPassword,
                    ),
                    const SizedBox(height: 20),
                    if (viewModel.passwordsMatch)
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Passwords match!',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (viewModel.currentStep > 0)
                    ElevatedButton(
                      onPressed: () {
                        viewModel.previousStep();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '  Back to Login  ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: viewModel.selectedRole != null
                        ? viewModel.nextStep
                        : null, // Disable until a role is selected
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viewModel.selectedRole != null
                          ? const Color(0xFF8BC34A)
                          : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      viewModel.currentStep < viewModel.totalSteps - 1
                          ? 'Next'
                          : 'Go',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}