import { View, ScrollView, Pressable } from 'react-native';
import { H2, H3, P, Muted, Large, Small } from '@/components/ui/typography';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Calendar as CalendarIcon, ChevronLeft, ChevronRight, Clock } from 'lucide-react-native';

export default function PlannerScreen() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const dates = [28, 29, 30, 31, 1, 2, 3];

    return (
        <ScrollView className="flex-1 bg-white p-4">
            <View className="mt-12 mb-6 flex-row justify-between items-center">
                <H2>Planner</H2>
                <Button variant="ghost" size="icon">
                    <CalendarIcon size={24} color="black" />
                </Button>
            </View>

            <View className="flex-row justify-between mb-6 bg-gray-50 p-4 rounded-xl">
                {days.map((day, i) => (
                    <View key={day} className="items-center">
                        <Small className="text-gray-500 mb-1">{day}</Small>
                        <View className={cn(
                            "h-10 w-10 rounded-full items-center justify-center",
                            dates[i] === 31 ? "bg-black" : ""
                        )}>
                            <Large className={dates[i] === 31 ? "text-white" : "text-black"}>{dates[i]}</Large>
                        </View>
                        {i % 3 === 0 && <View className="h-1 w-1 bg-red-500 rounded-full mt-1" />}
                    </View>
                ))}
            </View>

            <H3 className="mb-4">Today's Agenda</H3>
            <View className="space-y-4">
                <Card className="mb-4 border-l-4 border-l-blue-500">
                    <CardContent className="p-4 flex-row items-center">
                        <View className="bg-blue-50 p-2 rounded-lg mr-4">
                            <Clock size={20} color="#3b82f6" />
                        </View>
                        <View className="flex-1">
                            <Large>Review Anatomy</Large>
                            <Muted>09:00 AM - 09:30 AM</Muted>
                        </View>
                        <Button variant="ghost" size="sm" label="Start" />
                    </CardContent>
                </Card>

                <Card className="mb-4 border-l-4 border-l-red-500">
                    <CardContent className="p-4 flex-row items-center">
                        <View className="bg-red-50 p-2 rounded-lg mr-4">
                            <CalendarIcon size={20} color="#ef4444" />
                        </View>
                        <View className="flex-1">
                            <Large>Biology Exam</Large>
                            <Muted>01:00 PM • University Hall</Muted>
                        </View>
                    </CardContent>
                </Card>

                <Card className="mb-4 border-l-4 border-l-gray-300">
                    <CardContent className="p-4 flex-row items-center">
                        <View className="bg-gray-50 p-2 rounded-lg mr-4">
                            <Clock size={20} color="#6b7280" />
                        </View>
                        <View className="flex-1">
                            <Large>Gym Session</Large>
                            <Muted>05:00 PM - 06:00 PM</Muted>
                        </View>
                        <Muted>Life</Muted>
                    </CardContent>
                </Card>
            </View>
        </ScrollView>
    );
}

// Helper for cn in this file since I can't import it easily in the same block sometimes
function cn(...classes: string[]) {
    return classes.filter(Boolean).join(' ');
}
