import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/custom/widgets/custom_button_1.dart';
import 'package:sports_complex_ms/student_side_app/providers/student_details_provider.dart';
import 'package:sports_complex_ms/student_side_app/services/arena_services.dart';

class SlotDetailsWidget extends ConsumerStatefulWidget {
  const SlotDetailsWidget({
    super.key,
    required this.slotDetails,
    required this.index,
  });

  final Map<String, String?> slotDetails;
  final int index;

  @override
  ConsumerState<SlotDetailsWidget> createState() => _SlotDetailsWidgetState();
}

class _SlotDetailsWidgetState extends ConsumerState<SlotDetailsWidget> {
  Future<void> _bookSlot(BuildContext ctx) async {
    final studentDetails = ref.read(studentDetailsProvider);
    String usn = studentDetails!.usn;

    await ArenaServices().bookASlot(widget.slotDetails['slotNo']!,
        widget.slotDetails['arenaId']!, usn, ctx);

    if (ctx.mounted) {
      Navigator.of(ctx).pop(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.slotDetails['bookedBy'] == null ||
            widget.slotDetails['bookedBy']!.isEmpty) {
          showDialog(
            context: context,
            builder: (ctx) => SimpleDialog(
              contentPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 20.0, 20.0),
              title: const Text('Free Slot'),
              children: [
                const Text('No one has booked this slot...'),
                const SizedBox(height: 10),
                CustomButton1(
                  text: 'Book this slot',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _bookSlot(context);
                  },
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (ctx) => SimpleDialog(
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
              title: const Text('This slot is booked'),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    const Text('Please try again later...'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Okay'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
        clipBehavior: Clip.hardEdge,
        elevation: 5,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Slot ${widget.index + 1}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 35),
              Row(
                children: [
                  Icon(
                    Icons.hourglass_bottom_rounded,
                    size: 30,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Slot timings',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                      ),
                      //const SizedBox(height: 2),
                      Text(
                        '${widget.slotDetails['slotStartTime']!} - ${widget.slotDetails['slotEndTime']}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 40),
              widget.slotDetails['bookedBy'] == null
                  ? Row(
                      children: [
                        Icon(
                          Icons.event_available_rounded,
                          size: 30,
                          color: Colors.green.shade800,
                        ),
                        Text(
                          'Free',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.green.shade800,
                                  ),
                        ),
                      ],
                    )
                  : Icon(
                      Icons.event_busy_rounded,
                      size: 30,
                      color: Colors.red.shade800,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
