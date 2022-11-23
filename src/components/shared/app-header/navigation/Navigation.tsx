import React from 'react';
import {
  Box,
  Burger,
  Button,
  Center,
  Divider,
  Drawer,
  Group,
  Header,
  HoverCard,
  ScrollArea,
  UnstyledButton,
} from '@mantine/core';
import { MantineLogo } from '@mantine/ds';
import { useDisclosure } from '@mantine/hooks';
import Link from 'next/link';
import { Route } from '../AppHeader.constants';
import { useStyles } from './Navigation.styles';
import { signIn, signOut, useSession } from 'next-auth/react';

interface IProps {}

export const Navigation: React.FC<IProps> = (props) => {
  const { data: session } = useSession();
  const [drawerOpened, { toggle: toggleDrawer, close: closeDrawer }] =
    useDisclosure(false);
  const { classes, theme } = useStyles();

  return (
    <Box pb={120}>
      <Header height={60} px={'md'}>
        <Group position={'apart'} sx={{ height: '100%' }}>
          <MantineLogo size={30} />
          <Group
            className={classes.hiddenMobile}
            spacing={0}
            sx={{ height: '100%' }}
          >
            <Link className={classes.link} href={Route.Home}>
              Home
            </Link>
            <HoverCard
              position={'bottom'}
              radius={'md'}
              shadow={'md'}
              width={600}
              withinPortal={true}
            >
              <HoverCard.Target>
                <Link className={classes.link} href={Route.Flights}>
                  <Center inline={true}>
                    <Box component={'span'} mr={5}>
                      Flights
                    </Box>
                  </Center>
                </Link>
              </HoverCard.Target>
            </HoverCard>
            <Link className={classes.link} href={Route.Passengers}>
              Passengers
            </Link>
            <Link className={classes.link} href={Route.Schedule}>
              Schedule
            </Link>
          </Group>

          <Group className={classes.hiddenMobile}>
            {!session && (
              <React.Fragment>
                <Button variant={'default'} onClick={() => signIn()}>
                  Log in
                </Button>
                <Link href={Route.Register}>
                  <Button>Sign up</Button>
                </Link>
              </React.Fragment>
            )}
            {session && (
              <Button variant={'default'} onClick={() => signOut()}>
                Log Out
              </Button>
            )}
          </Group>

          <Burger
            className={classes.hiddenDesktop}
            opened={drawerOpened}
            onClick={toggleDrawer}
          />
        </Group>
      </Header>

      <Drawer
        className={classes.hiddenDesktop}
        opened={drawerOpened}
        padding={'md'}
        size={'100%'}
        title={'Navigation'}
        zIndex={1000000}
        onClose={closeDrawer}
      >
        <ScrollArea mx={'-md'} sx={{ height: 'calc(100vh - 60px)' }}>
          <Divider
            color={theme.colorScheme === 'dark' ? 'dark.5' : 'gray.1'}
            my={'sm'}
          />

          <Link className={classes.link} href={Route.Home}>
            Home
          </Link>

          <UnstyledButton className={classes.link}>
            <Center inline={true}>
              <Box component={'span'} mr={5}>
                Flights
              </Box>
            </Center>
          </UnstyledButton>

          <Link className={classes.link} href={Route.Passengers}>
            Passengers
          </Link>

          <Link className={classes.link} href={Route.Schedule}>
            Schedule
          </Link>

          <Divider
            color={theme.colorScheme === 'dark' ? 'dark.5' : 'gray.1'}
            my={'sm'}
          />

          <Group grow={true} pb={'xl'} position={'center'} px={'md'}>
            {session && (
              <Button variant={'default'} onClick={() => signIn()}>
                Log in
              </Button>
            )}
            {!session && (
              <React.Fragment>
                <Button variant={'default'} onClick={() => signIn()}>
                  Log in
                </Button>
                <Link href={Route.Register}>
                  <Button>Sign up</Button>
                </Link>
              </React.Fragment>
            )}
          </Group>
        </ScrollArea>
      </Drawer>
    </Box>
  );
};

Navigation.displayName = 'Navigation';
